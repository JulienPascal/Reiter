
type StrucParameters
    # Parameters
    β::Float64
    ϵ::Float64
    σ::Float64
    ϕ::Float64
    phi_taylor::Float64
    Nstst::Float64

    ##  Idio Stochastic Process  ##
    n_z::Int64
    Π_z::Matrix{Float64}
    z_vals::Vector{Float64}
    # z_dist::Vector{Float64}
    ind_z_x_z::Matrix{Int64}

    ## Aggregate Shock  ##
    σ_ii::Float64
    ρ_z::Float64
    σ_z::Float64

    ##  Menu Cost  ##
    ξ0::Float64
    ξbar::Float64
    H::Function
    cond_mean::Function

end

function SetParameters()
    β = 0.975
    ϵ = 5.0
    σ = 1.0
    ϕ = 0.5
    phi_taylor = 1.25

    #== Stochastic productivity ==#
    n_z = 10
    mc  = rouwenhorst(n_z, 0.9, 0.03)
    ##  WARN:  nodes are the exponencial     ##
    z_vals = exp(collect(mc.state_values))
    Π_z    = mc.p
    # z_dist =
    raw_ind = [collect(1:n) for n in (n_z, n_z)]
    ind_z_x_z = gridmake(raw_ind...)

    #== Aggregate shock ==#
    ρ_z = 0.96
    σ_z = 0.005
    σ_ii = 0.0025

    ξbar = 0.08 #0.05
    ξ0   = 0.04
    H(ξ) = (1.0/( ξbar - ξ0 )) .* (ξ - ξ0)
    cond_mean(ξ) = ( 1/(2*(ξbar-ξ0)) ) .* (ξ.^2 - ξ0^2)

    StrucParameters(β, ϵ, σ, ϕ, phi_taylor, 0.33, n_z, Π_z, z_vals, ind_z_x_z, σ_ii, ρ_z, σ_z, ξ0, ξbar, H, cond_mean)
end

macro getPar(P)
  return esc(
      quote
      β = $P.β
      ϵ = $P.ϵ
      σ = $P.σ
      ϕ = $P.ϕ
      phi_taylor = $P.phi_taylor
      Nstst = $P.Nstst

      n_z = $P.n_z
      Π_z = $P.Π_z
      z_vals = $P.z_vals
      ind_z_x_z = $P.ind_z_x_z

      σ_ii = $P.σ_ii
      ρ_z = $P.ρ_z
      σ_z = $P.σ_z

      ξ0 = $P.ξ0
      ξbar = $P.ξbar
      H = $P.H
      cond_mean = $P.cond_mean
      end;
  )
 end
