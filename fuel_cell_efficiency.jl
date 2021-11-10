### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ 2a85cad0-59eb-11eb-34ec-97f4dd5f7b02
using Pkg; Pkg.add(["Unitful", "SteamTables", "PhysicalConstants"]); using Unitful, SteamTables, PhysicalConstants.CODATA2018

# ╔═╡ f4610fd0-59b0-11eb-050f-8d78e358dc9a
md"# Fuel Cell performance tool"

# ╔═╡ e49df950-59ab-11eb-0eaf-71959cd1af89
md"An implimentation of the methods outlined in 'Acidic or Alkaline? Towards a New Perspective on the Efficiency of Water Electrolysis' Journal of The Electrochemical Society, 163 (11) F3197-F3208 (2016)"

# ╔═╡ 8b44dbe0-5cd4-11eb-3bf1-9b36cbd21e90
md"# Inputs for an alkaline fuel cell"

# ╔═╡ 24b03810-5cd5-11eb-1b50-9917c418031f
Description = "Jülich Alkaline Fuel Cell"

# ╔═╡ 8712e010-5cd6-11eb-0b91-7f2ac15cd7e2
d = 463u"μm"  #separator thickness

# ╔═╡ 8ef36f80-5cd5-11eb-0c06-89ffdcbee91b
k_sep = 0.164u"S*cm^-1"

# ╔═╡ 5a786b10-5cd6-11eb-3690-ffc38dfd7d85
R_hf = 0.246u"Ω * cm^2"

# ╔═╡ 557cc890-5cd6-11eb-1f7c-dbe414d70c9e
R_t = 0.362u"Ω * cm^2"

# ╔═╡ e1ba38f2-7b9a-11eb-20bd-f56c80a7497c


# ╔═╡ e3861f50-7b9a-11eb-0a0f-0d34699e1f35
md"Hydrogen partial pressure increase factor at the cathode"

# ╔═╡ 890c5b90-5cd5-11eb-321f-119bf7c9f9fe
Y_H2 = 0u"bar*cm^2*A^-1"

# ╔═╡ 1d955f10-5cd5-11eb-06eb-eb6d3d6ba11c
md"Oxygen partial pressure increase factor at the anode"

# ╔═╡ 4f6af8d0-7b9b-11eb-0b48-afc497476338
Y_O2 = 0u"bar*cm^2*A^-1"

# ╔═╡ 5466c4f0-80d6-11eb-210c-d10d45216c1c
md"# Operating parameters of the fuel cell"

# ╔═╡ 540ac240-80d6-11eb-31bc-a5749345dd6a
T = 80u"°C"

# ╔═╡ 53bf8870-80d6-11eb-0958-2b14cc9133ce
P_cath = 1u"bar"

# ╔═╡ 5508f100-80d9-11eb-1d1a-d510306c4e7d
P_ann = 1u"bar"

# ╔═╡ 246cc9e0-80d9-11eb-3413-4f8f8394052c
md"# Physical Constants"

# ╔═╡ 86a01af0-80ce-11eb-3ef9-3fc0140c239b
md"Universal gas constant"

# ╔═╡ 865c0d10-80ce-11eb-29b3-e7e8172c36ba
const R = MolarGasConstant

# ╔═╡ 854bd590-80ce-11eb-13ed-3b40c9bba328
#F = 96485u"C * mol^-1"
const F = AvogadroConstant * ElementaryCharge

# ╔═╡ 10c9a0c0-80d9-11eb-2314-a7ae0a8ed61f
const P_0 = StandardAtmosphere

# ╔═╡ 088c46f0-59ac-11eb-0415-e164db6c466b
md"U_rev is the reversible voltage, corresponding to Gibbs Free Energy or Lower heating Value. At standard ambient temperature it is 1.23V"

# ╔═╡ 272eb08e-59eb-11eb-19d5-8d3e9a8a473c
function U_rev(T::Unitful.Temperature)
	return 1.229u"V"-0.000846u"V*K^-1"*(T-298.15u"K")
end

# ╔═╡ 46221e90-5cd6-11eb-286e-39af85d09b7d
U_rev(20u"°C")

# ╔═╡ efd248d0-80d4-11eb-3016-d1400468b75c
function U_nernst(T::Unitful.Temperature, p_pres_H2_cath::Unitful.Pressure, p_press_O2_ann::Unitful.Pressure)
	# a_H2O is the activity of water. Dimensionless.  If water is present at the electrodes, it can be approximated as unity.
	a_H2O = 1;
	U_nernst = U_rev(T) + ((R * u"K"(T))/ (2 * F)) * log((p_pres_H2_cath * sqrt(p_press_O2_ann)) /
		(P_0 ^ (3/2) * a_H2O));
	return u"V"(U_nernst)
end
		

# ╔═╡ ef5e9f70-80d4-11eb-283f-5b3ab6575eb9
U_nernst(20u"°C", 1u"bar", 1u"bar")

# ╔═╡ eec25f70-80d4-11eb-3ee9-67eb79435c82


# ╔═╡ bafcfa22-59eb-11eb-04a1-0f4d1f124e95
md"U_tn us the thermoneutral voltage, corresponding to enthalpy or Higher heating Value at standard ambient temperature and pressure.
This takes into account the irreversible heat of evaporation for the phase transition of liquid water to gaseous hydrogen and oxygen
At cell voltages below the thermoneutral voltage, water electrolysis is endothermic, whereas at cell voltages above the thermoneutal voltage, water electrolysis is exothermic"

# ╔═╡ 6e0928a0-59ec-11eb-28ef-a9c6922262f3
U_tn = 1.48u"V"

# ╔═╡ 55583b80-5cd4-11eb-3f22-735b82d2735e


# ╔═╡ 36fdefc0-7b94-11eb-094a-599e067280e6
u"bar"(Psat(20u"°C"))

# ╔═╡ 36dd6f70-7b94-11eb-2e76-49dc0c6c50de


# ╔═╡ 358b9b10-7b94-11eb-133c-f1cfb0533e6f


# ╔═╡ 355ce9f0-7b94-11eb-2015-1b12f1f28ee2


# ╔═╡ 34cdf060-7b94-11eb-2ceb-f13b3cf57c5f


# ╔═╡ Cell order:
# ╟─f4610fd0-59b0-11eb-050f-8d78e358dc9a
# ╟─e49df950-59ab-11eb-0eaf-71959cd1af89
# ╠═2a85cad0-59eb-11eb-34ec-97f4dd5f7b02
# ╠═8b44dbe0-5cd4-11eb-3bf1-9b36cbd21e90
# ╠═24b03810-5cd5-11eb-1b50-9917c418031f
# ╠═8712e010-5cd6-11eb-0b91-7f2ac15cd7e2
# ╠═8ef36f80-5cd5-11eb-0c06-89ffdcbee91b
# ╠═5a786b10-5cd6-11eb-3690-ffc38dfd7d85
# ╠═557cc890-5cd6-11eb-1f7c-dbe414d70c9e
# ╠═e1ba38f2-7b9a-11eb-20bd-f56c80a7497c
# ╟─e3861f50-7b9a-11eb-0a0f-0d34699e1f35
# ╠═890c5b90-5cd5-11eb-321f-119bf7c9f9fe
# ╟─1d955f10-5cd5-11eb-06eb-eb6d3d6ba11c
# ╠═4f6af8d0-7b9b-11eb-0b48-afc497476338
# ╟─5466c4f0-80d6-11eb-210c-d10d45216c1c
# ╠═540ac240-80d6-11eb-31bc-a5749345dd6a
# ╠═53bf8870-80d6-11eb-0958-2b14cc9133ce
# ╠═5508f100-80d9-11eb-1d1a-d510306c4e7d
# ╟─246cc9e0-80d9-11eb-3413-4f8f8394052c
# ╟─86a01af0-80ce-11eb-3ef9-3fc0140c239b
# ╠═865c0d10-80ce-11eb-29b3-e7e8172c36ba
# ╠═854bd590-80ce-11eb-13ed-3b40c9bba328
# ╠═10c9a0c0-80d9-11eb-2314-a7ae0a8ed61f
# ╟─088c46f0-59ac-11eb-0415-e164db6c466b
# ╠═272eb08e-59eb-11eb-19d5-8d3e9a8a473c
# ╠═46221e90-5cd6-11eb-286e-39af85d09b7d
# ╠═efd248d0-80d4-11eb-3016-d1400468b75c
# ╠═ef5e9f70-80d4-11eb-283f-5b3ab6575eb9
# ╠═eec25f70-80d4-11eb-3ee9-67eb79435c82
# ╟─bafcfa22-59eb-11eb-04a1-0f4d1f124e95
# ╠═6e0928a0-59ec-11eb-28ef-a9c6922262f3
# ╠═55583b80-5cd4-11eb-3f22-735b82d2735e
# ╠═36fdefc0-7b94-11eb-094a-599e067280e6
# ╠═36dd6f70-7b94-11eb-2e76-49dc0c6c50de
# ╠═358b9b10-7b94-11eb-133c-f1cfb0533e6f
# ╠═355ce9f0-7b94-11eb-2015-1b12f1f28ee2
# ╠═34cdf060-7b94-11eb-2ceb-f13b3cf57c5f
