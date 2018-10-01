#!/usr/bin/fish
/usr/sbin/service nginx stop;
/usr/bin/certbot renew > renew_let_us_encrypt_cert.log;
set slack_webhook '{{ slack_webhook }}'
set domains (sudo grep 'success' renew_let_us_encrypt_cert.log | cut -d'/' -f 5)
for domain in $domains
        set payload  '{"attachments":[{"fallback":"'$domain' renew suceess","pretext":"ssl renew","color":"good","fields":[{"title":"'$domain'","value":"success","short":false}]}]}'
        curl -X POST $slack_webhook -H "Content-Type: application/json" -d $payload
end
/usr/sbin/service nginx start;