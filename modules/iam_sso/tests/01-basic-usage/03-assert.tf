resource "test_assertions" "this" {
  component = "basic-usage"

  equal "scheme" {
    description = "Just make sure that the module compiles."
    got         = "all good"
    want        = "all good"
  }
}
