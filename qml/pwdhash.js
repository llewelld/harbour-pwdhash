/*
Copyright 2014 Robert Gerlach

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the
      following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
      following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Stanford University nor the names of its contributors may be used to endorse or promote
      products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

.import "domain-extractor.js" as DomainExtractor
.import "password-extractor.js" as PasswordExtractor
.import "hashed-password.js" as HashedPassword

var password = "";

function domain_changed() {
    var value = inputSiteAddress.text;
    appwin.domain = (value) ? DomainExtractor.extractDomain(value) : "";
    _update_hashed_password();
}

function password_changed() {
    var value = inputSitePassword.text;
    password = (value) ? PasswordExtractor.extractPassword(value) : "";
    _update_hashed_password();
}

function _update_hashed_password() {
    var hashedPassword = "";
    if (appwin.domain && password)
        hashedPassword = HashedPassword.getHashedPassword(password, appwin.domain);
    appwin.hash = hashedPassword;
}

function copy_hashed_password() {
    if (inputHashedPassword.text) {
        inputHashedPassword.selectAll();
        inputHashedPassword.copy();
    }
}
