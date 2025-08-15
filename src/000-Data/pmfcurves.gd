class_name PMFCurves extends Resource
## Sample a vector of weighted values over [b]t[/b]
##
## This class can be used in two ways: to sample a changing distribution over 
## time or to use the assigned weights directly. 
## [br] [br]
## [b]Option 1: Sample changing distribution[/b]
## Define curves in [code]curves[/code]. Then call 
## [method PMFCurves.sample_index] to return the index of which curve "won"
## this time. The sampling uses the a normalized weight vector from
## [method PMFCurves.pmf_weights] to apply a standard probability mass 
## function. The outcome is the index of the winning curve.

## Define curves here to sample
@export var curves: Array[Curve]

## Returns the weighted vector @ position t in [member PMFCurves.curves]. 
## You must know ahead of the time domain of the curves to ensure you do not 
## sample out of bounds.
func pmf_weights(t: float) -> Array[float]:
	var pmf_w: Array[float] = []
	for c in curves:
		pmf_w.append(c.sample(fmod(t, c.max_domain)))
	return pmf_w

	## fuck gdscript!!!
	#var pmf_w: Array[float] = curves.map(
		#func f(c: Curve): return c.sample(fmod(t, c.max_domain)))
	#return pmf_w

## Utility function the calculate size |v| at position t where v is the vector
## sampled @ position t in [member PMFCurves.curves]
func pmf_sum_weights(t: float) -> float:
	return pmf_weights(t)\
		.reduce(func f(a, w): return a + w, 0)

## Applies PMF to the normalized vector sampled at t. Returns the index of the
## winning curve
func sample_index(t: float):
	var pmf_w = pmf_weights(t)
	var sum_w = pmf_sum_weights(t)
	
	# fuck gdscript!!
	#var pmf_v = pmf_w.map(func f(w): w / sum_w)
	
	var pmf_v: Array[float] = []
	for w in pmf_w:
		pmf_v.append(w / sum_w)
	
	var rnum := randf()
	var sum := 0.0
	for probability_i in range(len(pmf_v)):
		sum += pmf_v[probability_i]
		if rnum <= sum:
			return probability_i

	assert("Impossible! Contact Emil")
