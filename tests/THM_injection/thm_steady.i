#### A fully-coupled T-H-M simulation of
#### cold water injection into a hot reservoir
#### through the center of a pre-existing fault disk
#### Part 1.
####   A steady-state simulation to generate
####   initial conditions in the domain

#### Author of this script: Andy Wilkins of CSIRO

############################################################
[Mesh]
  file = mesh_vcoarse.e
  #file = mesh.e
  # -3.5km <= z <= -1.5km
[]
############################################################
[GlobalParams]
  displacements = 'sdisp_x sdisp_y sdisp_z'
  PorousFlowDictator = dictator
[]
############################################################
[Variables]
  [./P]
  [../]
  [./T]
  [../]
  [./sdisp_x]
  [../]
  [./sdisp_y]
  [../]
  [./sdisp_z]
  [../]
[]
############################################################
[ICs]
  [./P]
    type = FunctionIC
    function = '101325-z*9800'
    variable = P
  [../]
  [./T]
    type = FunctionIC
    function = '293-z*25.0/1000.0'
    variable = T
  [../]
[]
############################################################
[Functions]
  # the following is the initial effective stresses that should arise
  # from the weight force and the initial porepressure
  # grad(eff_stress) = grad(biot*porepressure) + solid_fluid_density*gravity
  [./weight_fcn]
    type = ParsedFunction
    vars = 'g B p0 rho0 biot'
    vals = '9.8 2.0E9 101325 999.526 1.0'
    value = 'biot*(101325-rho0*g*z)+2386.0*g*z'
  [../]
  [./kxx_fcn]
    type = ParsedFunction
    vars = 'g B p0 rho0 biot'
    vals = '9.8 2.0E9 101325 999.526 1.0'
    value = '2.05*(biot*(101325-rho0*g*z)+2386.0*g*z)'
  [../]
  [./kxy_fcn]
    type = ParsedFunction
    vars = 'g B p0 rho0 biot'
    vals = '9.8 2.0E9 101325 999.526 1.0'
    value = '0.16*(biot*(101325-rho0*g*z)+2386.0*g*z)'
  [../]
  [./kyy_fcn]
    type = ParsedFunction
    vars = 'g B p0 rho0 biot'
    vals = '9.8 2.0E9 101325 999.526 1.0'
    value = '0.18*(biot*(101325-rho0*g*z)+2386.0*g*z)'  # plasticity=0.18 noplasticity=0.2.  should be 1.8
  [../]
[]
############################################################
[Kernels]
  #[./P_time_deriv]
  #  type = PorousFlowMassTimeDerivative
  #  fluid_component = 0
  #  variable = P
  #[../]
  [./P_flux]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    variable = P
    gravity = '0 0 -9.8'
  [../]
  #[./energy_dot]
  #  type = PorousFlowEnergyTimeDerivative
  #  variable = T
  #[../]
  [./heat_conduction]
    type = PorousFlowHeatConduction
    variable = T
  [../]
  #[./heat_advection]
  #  type = PorousFlowHeatAdvection
  #  variable = T
  #  gravity = '0 0 -9.8'
  #[../]
  [./grad_stress_x]
    type = StressDivergenceTensors
    variable = sdisp_x
    component = 0
  [../]
  [./grad_stress_y]
    type = StressDivergenceTensors
    variable = sdisp_y
    component = 1
  [../]
  [./grad_stress_z]
    type = StressDivergenceTensors
    variable = sdisp_z
    component = 2
  [../]
  [./gravity_z]
    type = Gravity
    variable = sdisp_z
    value = -9.8
  [../]
  [./poro_x]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 1.0
    variable = sdisp_x
    component = 0
  [../]
  [./poro_y]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 1.0
    variable = sdisp_y
    component = 1
  [../]
  [./poro_z]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 1.0
    variable = sdisp_z
    component = 2
  [../]
  #[./poro_vol_exp]
  #  type = PorousFlowMassVolumetricExpansion
  #  variable = P
  #  fluid_component = 0
  #[../]
  #[./heat_vol_exp]
  #  type = PorousFlowEnergyVolumetricExpansion
  #  variable = T
  #[../]
[]
############################################################
[BCs]
  # 1 = zmax
  # 2 = zmin
  # 3 = xmin
  # 4 = xmax
  # 5 = ymin
  # 6 = ymax
  [./P_top]
    type = FunctionPresetBC
    variable = P
    boundary = '1'
    function = '101325-z*9800'
  [../]
  [./T_top]
    type = FunctionPresetBC
    variable = T
    boundary = '1'
    function = '293-z*25.0/1000.0'
  [../]
  [./T_bot]
    type = FunctionPresetBC
    variable = T
    boundary = '2'
    function = '293-z*25.0/1000.0'
  [../]
  [./roller_x]
    type = PresetBC
    variable = sdisp_x
    value = 0
    boundary = '3 4'
  [../]
  [./roller_y]
    type = PresetBC
    variable = sdisp_y
    value = 0
    boundary = '5 6'
  [../]
  [./bottom_z]
    type = PresetBC
    variable = sdisp_z
    value = 0
    boundary = '2'
  [../]
  [./top_z]
    type = Pressure
    variable = sdisp_z
    component = 2
    function = '-2386.0*9.8*z'
    use_displaced_mesh = false
    boundary = '1'
  [../]
[]
############################################################
[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]
############################################################
[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yx
    index_i = 1
    index_j = 0
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zx
    index_i = 2
    index_j = 0
  [../]
  [./stress_zy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zy
    index_i = 2
    index_j = 1
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
[]
############################################################
[UserObjects]
  [./dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'P T sdisp_x sdisp_y sdisp_z'
    number_fluid_phases = 1
    number_fluid_components = 1
  [../]
  [./ts]
    # large so that there is no plastic deformation
    type = TensorMechanicsHardeningConstant
    value = 1E16
  [../]
  [./mc]
    # irrelevant for this simulation
    type = TensorMechanicsPlasticTensile
    tensile_strength = ts
    yield_function_tolerance = 1E-6
    tensile_tip_smoother = 1.0
    internal_constraint_tolerance = 1E-5
  [../]
[]
############################################################
[Materials]
  [./temperature]
    type = PorousFlowTemperature
    temperature = T
  [../]
  [./temperature_nodal]
    type = PorousFlowTemperature
    at_nodes = true
    temperature = T
  [../]
  [./rock_heat]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 920.0
    density = 2540.0
  [../]
  [./fluid_energy]
    type = PorousFlowInternalEnergyIdeal
    at_nodes = true
    specific_heat_capacity = 4180.0
    phase = 0
  [../]
  [./energy_all]
    type = PorousFlowJoiner
    include_old = true
    at_nodes = true
    material_property = PorousFlow_fluid_phase_internal_energy_nodal
  [../]
  [./fluid_enthalpy]
    type = PorousFlowEnthalpy
    at_nodes = true
    phase = 0
  [../]
  [./enthalpy_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_enthalpy_nodal
  [../]
  [./thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '1.0 0 0  0 1.0 0  0 0 1.0'
  [../]
  [./ppss]
    type = PorousFlow1PhaseP_VG
    at_nodes = true
    porepressure = P
    al = 1
    m = 0.5
  [../]
  [./ppss_qp]
    type = PorousFlow1PhaseP_VG
    porepressure = P
    al = 1
    m = 0.5
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./dens0]
    type = PorousFlowDensityConstBulk
    at_nodes = true
    density_P0 = 999.526
    bulk_modulus = 2.0E9
    phase = 0
  [../]
  [./dens_all]
    type = PorousFlowJoiner
    at_nodes = true
    include_old = true
    material_property = PorousFlow_fluid_phase_density_nodal
  [../]
  [./dens0_qp]
    type = PorousFlowDensityConstBulk
    density_P0 = 999.526
    bulk_modulus = 2.0E9
    phase = 0
  [../]
  [./dens_qp_all]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
    at_nodes = false
  [../]
  [./visc0]
    type = PorousFlowViscosityConst
    at_nodes = true
    viscosity = 1E-3
    phase = 0
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_viscosity_nodal
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1.0E-12 0 0  0 1.0E-12 0  0 0 1.0E-12'
  [../]
  [./relperm]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = true
    n = 1
    phase = 0
  [../]
  [./relperm_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_relative_permeability_nodal
  [../]
  [./porosity]
    type = PorousFlowPorosityConst
    at_nodes = true
    porosity = 0.1
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    C_ijkl = '8.65E9 5.77E9' # young = 15GPa, poisson = 0.3
    fill_method = symmetric_isotropic
  [../]
  [./thermal_expansion_strain]
    type = ComputeThermalExpansionEigenstrain
    stress_free_temperature = 293
    thermal_expansion_coeff = 1.0E-5
    temperature = T
    incremental_form = true
    eigenstrain_name = eigenstrain
  [../]
  [./strain]
    type = ComputeIncrementalSmallStrain
  [../]
  [./stress]
    type = ComputeMultiPlasticityStress
    initial_stress = 'kxx_fcn kxy_fcn 0  kxy_fcn kyy_fcn 0  0 0 weight_fcn'
    # the rest of this stuff is irrelevant for this test
    ep_plastic_tolerance = 1E-5
    plastic_models = mc
    debug_fspb = crash
  [../]
  [./density]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 2386.0 # = (1-0.1)*2540 + 0.1*999.526
  [../]
  [./eff_fluid_pressure]
    type = PorousFlowEffectiveFluidPressure
    at_nodes = true
  [../]
  [./eff_fluid_pressure_qp]
    type = PorousFlowEffectiveFluidPressure
  [../]
  #[./vol_strain]
  #  type = PorousFlowVolumetricStrain
  #[../]
[]
############################################################
[Preconditioning]
  active = 'superlu'
  [./original]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm lu NONZERO'
  [../]
  [./superlu]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-ksp_type -pc_type -pc_factor_mat_solver_package'
    petsc_options_value = 'gmres lu superlu_dist'
  [../]
  [./sub_pc_superlu]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -sub_pc_factor_mat_solver_package'
    petsc_options_value = 'gmres asm lu NONZERO superlu_dist'
  [../]
[]
############################################################
[Executioner]
  type = Steady

  solve_type = 'NEWTON' # default = PJFNK | NEWTON

  l_max_its  = 20
  l_tol      = 1e-4
  nl_max_its = 500
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-6
[]
############################################################
[Outputs]
  file_base      = thm_steady_out
  exodus         = true
  [./console]
    type = Console
    perf_log = false
    output_linear = true
    output_nonlinear = true
  [../]
[]
############################################################
