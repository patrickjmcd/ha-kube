// resource "null_resource" "secrets_sops" {
//   provisioner "local-exec" {
//     command = "../../aws_sops/decrypt_secrets.sh"
//   }
// }

data "kubectl_filename_list" "listed_decrypted_secrets" {
    // depends_on = [null_resource.secrets_sops]
    pattern = "../../roles/k3s_deploy/files/secrets_decrypted/*.yaml"
}

resource "kubectl_manifest" "decrypted_secrets" {
    // depends_on = [data.kubectl_filename_list.listed_decrypted_secrets]
    count     = length(data.kubectl_filename_list.listed_decrypted_secrets.matches)
    yaml_body = file(element(data.kubectl_filename_list.listed_decrypted_secrets.matches, count.index))
}