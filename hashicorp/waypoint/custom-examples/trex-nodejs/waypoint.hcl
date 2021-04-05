project = "custom-example-nodejs"
app "custom-example-nodejs" {
  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "star3am/repository"
        tag = "nodejs-example"
        local = true
        # { "username": "USERNAME", "password": "PASSWORD", "email": "EMAIL_ADDRESS" }
        encoded_auth = filebase64("/etc/docker/auth.json")
      }
    }
  }
  deploy {
    use "nomad" {
      datacenter = "dc1"
    }
  }
}
