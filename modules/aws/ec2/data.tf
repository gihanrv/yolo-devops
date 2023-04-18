data "aws_vpc" "this" {
  id = var.vpc_id
}

data "template_file" "user_data" {

  template = file("${path.module}/conf/${local.stack_name}.tpl")
  vars = {
    git_repo_url = var.git_repo_url,
    git_repo_name =  var.git_repo_name,
    git_branch = var.git_branch,
    message = var.instance_names[count.index],
    stack = var.stack
  }
 
}