class DataSourceController < ApplicationController

  # render the list of borrowers in the db according to a query passed to the action
  def borrowers_list
    query=params[:query]
    string_query=query.to_s
    if string_query.nil? || string_query.empty?
      the_list=Borrower.all().order(:name)
    else
      the_list=Borrower.all().where("name ILIKE '%#{string_query}%' OR first_name ILIKE '%#{string_query}%'").order(:name)
    end
    final_list= Array.new
    the_list.each do |borrower|
      temp_hash= {:name => borrower.reverse_full_name, :value => borrower.id}
      final_list.push(temp_hash)
    end
    respond_to do |format|
      format.json {
        render json: {:success => true, :results => final_list }
      }
    end
  end

end