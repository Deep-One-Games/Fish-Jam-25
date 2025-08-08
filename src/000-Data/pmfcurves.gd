class_name PMFCurves extends Resource

@export var curves: Array[Curve]

func pmf_weights(t: float) -> Array[float]:
	return curves.map(func f(c): return c.sample(t))

func pmf_sum_weights(t: float) -> float:
	return pmf_weights(t)\
		.reduce(func f(a, w): return a + w, 0)

func sample_index(t: float):
	var pmf_w = pmf_weights(t)
	var sum_w = pmf_sum_weights(pmf_w)
	
	var pmf_v = pmf_w.map(func f(w): w / sum_w)
	
	var rnum := randf()
	var sum := 0.0
	for probability_i in range(len(pmf_v)):
		sum += pmf_v[probability_i]
		if rnum <= sum:
			return probability_i

	assert("Impossible! Contact Emil")
