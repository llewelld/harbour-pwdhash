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
.pragma library
.import QtQuick.LocalStorage 2.0 as QTQLS

var _database = false

function _getDatabase() {
    if (!_database) {
        _database = QTQLS.LocalStorage.openDatabaseSync("history", "1.0", "Description", 100000);
        _database.transaction(function(tx){
            tx.executeSql("CREATE TABLE IF NOT EXISTS domains(domain TEXT PRIMARY KEY, counter INTEGER DEFAULT 0)");
        });
    }
    return _database;
}

function search(str) {
    var db = _getDatabase();
    if (!db) return false;

    var domains = Array();
    db.readTransaction(function(tx){
        var result = tx.executeSql(
                "SELECT domain FROM domains " +
                "WHERE domain LIKE ? " +
                "ORDER BY counter DESC " +
                "LIMIT ?",
                [ str+'%', 5 ]);

        for (var j=0; j<result.rows.length; j++) {
            var s = result.rows.item(j).domain
            if (s != str)
                domains.push(s);
        }
    });

    return domains;
}

function store(domain) {
    var db = _getDatabase();
    if (!db) return false;

    if ((domain) && (domain.length > 3)) {
        db.transaction(function(tx){
            var result = tx.executeSql("UPDATE domains SET counter=counter+1 WHERE domain=?", [domain]);
            if (result.rowsAffected == 0)
                tx.executeSql("INSERT INTO domains (domain,counter) VALUES (?,?)", [domain, 1]);
        });
    }
}

function clear() {
    var db = _getDatabase();
    if (!db) return false;

    db.transaction(function(tx){
        tx.executeSql("DELETE FROM domains");
    })
}
