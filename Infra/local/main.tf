resource local_file myfile {
	filename = "automate.txt"
	content = "Hello...! This is from Terraform..."

}

resource local_file ansible {
	filename = "config.txt"
	content = "thi is configration file"
}