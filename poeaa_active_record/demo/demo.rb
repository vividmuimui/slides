require "active_record"

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "demo.sqlite3"
)

class Registory
  class << self
    def person(id) ;end
    def add_person(person); end
  end
end

class People
  FIND_SQL = "SELECT id, lastname, firstname, number_of_dependents FROM people WHERE id = ?;"
  UPDATE_SQL = "UPDATE people SET lastname = :lastname, firstname = :firstname, number_of_dependents = :number_of_dependents WHERE id = :id;"
  INSERT_SQL = "INSERT INTO people(id, lastname, firstname, number_of_dependents) VALUES (:id, :lastname, :firstname, :number_of_dependents);"

  class << self
    # キャッシュ周りのロジックは省略しました
    def find(id)
      # SQLをいい感じに組み立てて実行
      row_hash = con.select_one(ActiveRecord::Base.send(:sanitize_sql_array, [FIND_SQL, id]))
      new(row_hash.symbolize_keys) if row_hash # レコードが見つかったら自身のインスタンスを作成する
    end

    def con
      @con ||= ActiveRecord::Base.connection
    end
  end

  attr_accessor :id, :lastname, :firstname, :number_of_dependents

  def initialize(id: nil, lastname: nil, firstname: nil, number_of_dependents: nil)
    @id, @lastname, @firstname, @number_of_dependents = id, lastname, firstname, number_of_dependents
  end

  def update
    self.class.con.execute(ActiveRecord::Base.send(:sanitize_sql_array, [UPDATE_SQL, attributes]))
  end

  def insert
    self.class.con.execute(ActiveRecord::Base.send(:sanitize_sql_array, [INSERT_SQL, attributes]))
  end

  def exemption
    base = 1500
    dependent = 750
    base + dependent * number_of_dependents
  end

  def attributes
    {
      id: id,
      firstname: firstname,
      lastname: lastname,
      number_of_dependents: number_of_dependents
    }
  end
end

ActiveRecord::Base.connection.execute("drop table people;") rescue nil

class CreatPeoples < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :lastname
      t.string :firstname
      t.integer :number_of_dependents
    end
  end
end

CreatPeoples.migrate(:up)

# 初期データを用意
People.new(id: 1, firstname: "foo", lastname: "bar", number_of_dependents: 100).insert

# select
people = People.find(1)

# update
people = People.find(1)
people.lastname = "hoge"
people.update
People.find(1)

# insert
people = People.new(id: 2, firstname: "hoge", lastname: "huga", number_of_dependents: 200)
people.insert
class CheatPeople < ActiveRecord::Base
  self.table_name = "people"
end
CheatPeople.all

# ビジネスロジック
People.find(1).exemption
People.find(2).exemption
