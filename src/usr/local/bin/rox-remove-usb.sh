#!/bin/sh
env DISPLAY=:0 rox --RPC << EOF
<?xml version="1.0"?>
<env:Envelope xmlns:env="http://www.w3.org/2001/12/soap-envelope">
 <env:Body xmlns="http://rox.sourceforge.net/SOAP/ROX-Filer">
  <PinboardRemove>
   <Path>$1</Path>
  </PinboardRemove>
 </env:Body>
</env:Envelope>
EOF
