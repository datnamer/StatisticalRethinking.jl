using StatisticalRethinking
using Turing

Turing.setadbackend(:reverse_diff)

d = CSV.read(joinpath(dirname(Base.pathof(StatisticalRethinking)), "..", "data",
    "Kline.csv"), delim=';')
size(d) # Should be 10x5

# New col log_pop, set log() for population data
d[:log_pop] = map((x) -> log(x), d[:population])
d[:society] = 1:10

@model m12_6(total_tools, log_pop, society) = begin

    # Total num of y
    N = length(total_tools)

    # priors
    α ~ Normal(0, 10)
    βp ~ Normal(0, 1)

    # Separate σ priors for each society
    σ_society ~ Truncated(Cauchy(0, 1), 0, Inf)

    # Number of unique societies in the data set
    N_society = length(unique(society)) #10

    # Vector of societies (1,..,10) which we'll set priors on
    α_society = Vector{Real}(undef, N_society)

    # For each society [1,..,10] set a prior N(0, σ_society)
    α_society ~ [Normal(0, σ_society)]

    for i ∈ 1:N
        λ = exp(α + α_society[society[i]] + βp*log_pop[i])
        total_tools[i] ~ Poisson(λ)
    end
end

posterior = sample(m12_6(d[:total_tools], d[:log_pop],
    d[:society]), Turing.NUTS(4000, 1000, 0.95))
describe(posterior)
#                    Mean             SD           Naive SE           MCSE          ESS
#             α    1.1182854734    0.6838347415   0.010812376632   0.08602324289   63.193251
#            βp    0.0015727917    2.1232910938   0.033572179960   0.24956867331   72.383393
#  α_society[1]   -0.1316993539    0.3202636299   0.005063812611   0.03989252088   64.451389
#  α_society[2]    0.1172002845    0.4129021244   0.006528555819   0.05855032777   49.731960
#  α_society[3]    0.0180060671    0.3150966952   0.004982116201   0.04176133073   56.929719
#  α_society[4]    0.3876256610    0.3197892507   0.005056312018   0.04219533560   57.437937
#  α_society[5]    0.1160043096    0.3337684945   0.005277343269   0.04609127859   52.438851
#  α_society[6]   -0.2005007396    0.4911448140   0.007765681367   0.07098952456   47.866381
#  α_society[7]    0.2220649916    0.3747451279   0.005925240730   0.05339055099   49.265533
#  α_society[8]   -0.0791480898    0.3522015990   0.005568796243   0.04852878098   52.672494
#  α_society[9]    0.3551482343    0.3663680005   0.005792786717   0.05177556958   50.070889
# α_society[10]   -0.0128289452    0.3248066136   0.005135643490   0.03415921269   90.413654
#     σ_society    0.6099550077    1.9077543930   0.030164245491   0.29487628802   41.856723

# Rethinking
#               Mean StdDev lower 0.89 upper 0.89 n_eff Rhat
# a              1.11   0.75      -0.05       2.24  1256    1
# bp             0.26   0.08       0.13       0.38  1276    1
# a_society[1]  -0.20   0.24      -0.57       0.16  2389    1
# a_society[2]   0.04   0.21      -0.29       0.38  2220    1
# a_society[3]  -0.05   0.19      -0.36       0.25  3018    1
# a_society[4]   0.32   0.18       0.01       0.60  2153    1
# a_society[5]   0.04   0.18      -0.22       0.33  3196    1
# a_society[6]  -0.32   0.21      -0.62       0.02  2574    1
# a_society[7]   0.14   0.17      -0.13       0.40  2751    1
# a_society[8]  -0.18   0.19      -0.46       0.12  2952    1
# a_society[9]   0.27   0.17      -0.02       0.52  2540    1
# a_society[10] -0.10   0.30      -0.52       0.37  1433    1
# sigma_society  0.31   0.13       0.11       0.47  1345    1
