sendmail:
  pkg.installed

/etc/mail/authinfo:
  file.managed:
    - source: salt://mail/authinfo
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/mail/access:
  file.managed:
    - source: salt://mail/access
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/mail/sendmail.mc:
  file.managed:
    - source: salt://mail/sendmail.mc
    - user: root
    - group: root
    - mode: 644
    - template: jinja

generate-authinfo-db:
  cmd.wait:
    - name: |
        sudo makemap hash /etc/mail/authinfo.db < /etc/mail/authinfo
    - watch:
      - file: /etc/mail/authinfo

generate-access-db:
  cmd.wait:
    - name: |
        sudo makemap hash /etc/mail/access.db < /etc/mail/access
    - watch:
      - file: /etc/mail/access

generate-sendmail-cf:
  cmd.wait:
    - name: |
        sudo m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
        sudo chmod 644 /etc/mail/sendmail.cf
        sudo /etc/init.d/sendmail restart
    - watch:
      - file: /etc/mail/sendmail.mc
