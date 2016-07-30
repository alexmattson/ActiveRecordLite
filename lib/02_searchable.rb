require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = "#{params.keys.join(" = ? AND ")} = ?"
    atts = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    atts.map{|att| self.new(att)}
  end

end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
