class ImportController < ApplicationController
  def new
  end

  def create
    file = params[:file]
    ImportService.import_data(file)
    redirect_to people_path, notice: 'CSV imported successfully.'
  end
end
