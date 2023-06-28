/*########################_EKS Configuration_###########################*/
variable "clusterName" {
  description = "Cluster name"
  type        = string
  default     = "randomName-EKS"
}//EOF cluster_name
/*#####################_End OF EKS Configuration_#######################*/

/*########################_Nodes Configuration_###########################*/
variable "instanceType" {
    description = "The type of instance to launch"
    type        = string
    default     = "t3.xlarge"
}//End OF instanceType
variable "scalingDesiredSize" {
    description = "Desired size of managed nodes group"
    type        = number
    default     = 1
}//End OF scalingDesiredSize

variable "scalingMaxSize" {
    description = "Maximum size of managed nodes group"
    type        = number
    default     = 3
}//End OF scalingMaxSize

variable "scalingMinSize" {
    description = "Minimum size of managed nodes group"
    type        = number
    default     = 1
}//End OF scalingMinSize

variable "diskSize" {
    description = "Disk size in GB of managed nodes"
    default     = "25"
}//EOF diskSize
/*#####################_End OF Nodes Configuration_#######################*/