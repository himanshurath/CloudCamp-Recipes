cookbook_file "/tmp/mydb-init.sql" do
    source "mydb-init.sql"
end

node[:deploy].each do |app_name, deploy|
  execute "initialize mysql tables" do
    command "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}  < /tmp/mydb-init.sql"
    not_if "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} -e'SHOW TABLES' | grep #{node[:phpapp][:dbtable]}"
    action :run
  end
end

