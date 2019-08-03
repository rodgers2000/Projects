a = rnorm(10)
diff_a = diff(a)
new_a = c(a[1])
for (i in 1:length(diff_a)) {
  j = diff_a[i] + new_a[i]
  new_a = c(new_a, j)
  print(new_a)
}
