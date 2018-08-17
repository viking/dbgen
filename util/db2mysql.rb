require 'mysql2'
require 'highline'

cli = HighLine.new
password = cli.ask("MySQL password: ") { |q| q.echo = false }
client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => password)

database = cli.ask("Database to create: ")
table = cli.ask("Table to create: ")
client.query("CREATE DATABASE IF NOT EXISTS #{database}")
client.query(<<EOF)
CREATE TABLE #{database}.#{table} (
  cluster_id INT,
  record_id INT,
  ssn VARCHAR(9),
  first VARCHAR(63),
  middle VARCHAR(15),
  last VARCHAR(63),
  street_num VARCHAR(15),
  street_name VARCHAR(63),
  apt VARCHAR(15),
  city VARCHAR(63),
  state VARCHAR(2),
  zip VARCHAR(5)
)
EOF

statement = client.prepare(<<EOF)
INSERT INTO #{database}.#{table}
  (cluster_id, record_id, ssn, first, middle, last, street_num, street_name, apt, city, state, zip)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
EOF
File.open("output.db", "r") do |f|
  while !f.eof?
    line = f.readline
    args = line.split(":").collect { |col| col.empty? ? nil : col }
    statement.execute(*args)
  end
end
