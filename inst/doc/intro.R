## ---- echo = FALSE, message = FALSE-----------------------------------------------------------------------------------
unlink("~/myapp", recursive = TRUE)
knitr::opts_chunk$set(comment = "")
library(gpg)
options(width = 120)

## ---------------------------------------------------------------------------------------------------------------------
str(gpg_info())

## ---------------------------------------------------------------------------------------------------------------------
gpg_restart(home = "~/myapp")

## ---------------------------------------------------------------------------------------------------------------------
gpg_keylist()

## ---------------------------------------------------------------------------------------------------------------------
(mykey <- gpg_keygen(name = "Jerry", email = "jerry@gmail.com"))
gpg_keylist()[c("id", "name", "email")]

## ---------------------------------------------------------------------------------------------------------------------
curl::curl_download("https://stallman.org/rms-pubkey.txt", "rms-pubkey.txt")
gpg_import("rms-pubkey.txt")
unlink("rms-pubkey.txt")

## ---------------------------------------------------------------------------------------------------------------------
gpg_recv(id ="E084DAB9")
keyring <- gpg_keylist()
keyring[c("id", "name", "email")]

## ---------------------------------------------------------------------------------------------------------------------
secring <- gpg_keylist(secret = TRUE)
secring[c("id", "name", "email")]

## ---------------------------------------------------------------------------------------------------------------------
str <- gpg_export(id = mykey)
cat(str)

## ---------------------------------------------------------------------------------------------------------------------
str <- gpg_export(id = mykey, secret = TRUE)
cat(str)

## ---------------------------------------------------------------------------------------------------------------------
gpg_delete('2C6464AF2A8E4C02')
gpg_keylist()[c("id", "name", "email")]

## ---- message=FALSE---------------------------------------------------------------------------------------------------
myfile <- tempfile()
writeLines("This is a secret message", con = myfile)
sig <- gpg_sign(myfile, mykey)
cat(sig)
writeLines(sig, "myfile.sig")

## ---------------------------------------------------------------------------------------------------------------------
gpg_verify(myfile, signature = "myfile.sig")
unlink("myfile.sig")

## ---------------------------------------------------------------------------------------------------------------------
# take out the spaces
johannes <- gsub(" ", "", "6212 B7B7 931C 4BB1 6280  BA13 06F9 0DE5 381B A480")
gpg_recv(johannes)

# Verify the file
library(curl)
curl_download('https://cran.r-project.org/bin/linux/debian/jessie-cran3/Release', 'Release')
curl_download('https://cran.r-project.org/bin/linux/debian/jessie-cran3/Release.gpg', 'Release.gpg')
gpg_verify('Release', 'Release.gpg')

## ---- echo = FALSE----------------------------------------------------------------------------------------------------
unlink('Release')
unlink('Release.gpg')

## ---------------------------------------------------------------------------------------------------------------------
glenn <- '734A3680A438DD45AF6F5B99A4A928C769CD6E44'
gpg_recv(glenn)
writeLines("TTIP is super evil!", "secret.txt")
msg <- gpg_encrypt("secret.txt", receiver = glenn)
writeLines(msg, "msg.gpg")
unlink("secret.txt")
cat(msg)

## ---- error=TRUE, message=FALSE---------------------------------------------------------------------------------------
# This will error, we do not have this private key
gpg_decrypt("msg.gpg")

## ---------------------------------------------------------------------------------------------------------------------
writeLines("This is a test!", "secret.txt")
msg <- gpg_encrypt("secret.txt", receiver = mykey)
writeLines(msg, "msg.gpg")
cat(msg)

## ---- message=FALSE---------------------------------------------------------------------------------------------------
gpg_decrypt("msg.gpg")

## ---------------------------------------------------------------------------------------------------------------------
msg <- gpg_encrypt("secret.txt", receiver = glenn, signer = mykey)
writeLines(msg, "msg.gpg")
cat(msg)

## ---- message=FALSE---------------------------------------------------------------------------------------------------
msg <- gpg_encrypt("secret.txt", receiver = mykey, signer = mykey)
writeLines(msg, "msg.gpg")
gpg_decrypt("msg.gpg")

## ---- echo = FALSE----------------------------------------------------------------------------------------------------
unlink("msg.gpg")
unlink("secret.txt")

