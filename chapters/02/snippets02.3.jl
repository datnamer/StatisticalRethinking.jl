using Distributions, RDatasets, DataFrames, Plots

@show ways  = [0  , 3 , 8 , 9 , 0 ];
@show ways/sum(ways)

@show d = Binomial(9, 0.5);
@show pdf(d, 6)

p_grid = range( 0 , stop=1 , length=20 )

prior = ones( 20 )

likelihood = [pdf(Binomial(9, p), 6) for p in p_grid]

unstd_posterior = likelihood .* prior

posterior = unstd_posterior  ./ sum(unstd_posterior)

p1 = plot( p_grid , posterior ,
    xlab="probability of water" , ylab="posterior probability",
    lab = "interpolated", title="20 points" )
p2 = scatter!( p1, p_grid , posterior, lab="computed" )

savefig("s2_4.pdf")

prior1 = [p < 0.5 ? 0 : 1 for p in p_grid]
prior2 = [exp( -5*abs( p - 0.5 ) ) for p in p_grid]

p3 = plot(p_grid, prior1,
  xlab="probability of water" , ylab="posterior probability",
  lab = "semi_uniform", title="Other priors" )
p4 = plot!(p3, p_grid, prior2,  lab = "double_exponential" )

savefig("s2_5.pdf")

p_grid = range(0, step=0.1, stop=1)
prior = ones(length(p_grid))
likelihood = [pdf(Binomial(9, p), 6) for p in p_grid]
posterior = likelihood .* prior
posterior = posterior / sum(posterior)

w = 6
n = 9
x = 0:0.01:1
plot( x, pdf.(Beta( w+1 , n-w+1 ) , x ), lab="Conjugate solution")

plot!( x, pdf.(Normal( 0.67 , 0.16 ) , x ), lab="Normal approximation")
savefig("s2_7.pdf")

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

