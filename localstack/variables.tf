variable "ec2_instance" {
  type = list(
    object({
      ami_id         = string
      instance_type  = string
      az             = string
      set_public_ip  = bool
      subnet_id      = string
      security_group = list(string)
      tags           = map(string)
      ebs_disks = list(
        object({
          disksize   = number
          encryption = bool
          disktype   = string
          devicename = string
      }))
    })
  )
  default = [
    {
      ami_id        = 123
      instance_type = "t1.micro"
      az            = 123
      set_public_ip = false
      subnet_id     = "oneal3j42rawefz"
      security_group = [
        "onealwijer"
      ]
      tags = {
        apple = "onebanana"
        pear  = "onepear"
      }
      ebs_disks = [
        {
          disksize   = 123
          encryption = true
          disktype   = "oneone342ewrgs4"
          devicename = "oneonealij32krwe"
        },
        {
          disksize   = 12
          encryption = false
          disktype   = "onetwo342ewrgs4"
          devicename = "onetwoalij32krwe"
        }
      ]
    },
    {
      ami_id        = 123333
      instance_type = "t1.micro"
      az            = 123333
      set_public_ip = false
      subnet_id     = "twoal3j42rawefz"
      security_group = [
        "twoalwijer"
      ]
      tags = {
        apple = "twobanana"
        pear  = "twopear"
      }
      ebs_disks = [
        {
          disksize   = 123
          encryption = true
          disktype   = "twoone342ewrgs4"
          devicename = "twoonealij32krwe"
        },
        {
          disksize   = 12
          encryption = false
          disktype   = "twotwo342ewrgs4"
          devicename = "twotwoalij32krwe"
        }
      ]
    },
    {
      ami_id        = 126666
      instance_type = "t1.micro"
      az            = 126666
      set_public_ip = false
      subnet_id     = "threeal3j42rawefz"
      security_group = [
        "threealwijer"
      ]
      tags = {
        apple = "threebanana"
        pear  = "threepear"
      }
      ebs_disks = [
        {
          disksize   = 123
          encryption = true
          disktype   = "threene342ewrgs4"
          devicename = "threeonealij32krwe"
        },
        {
          disksize   = 12
          encryption = false
          disktype   = "threetwo342ewrgs4"
          devicename = "threetwoalij32krwe"
        }
      ]
    }
  ]
}
