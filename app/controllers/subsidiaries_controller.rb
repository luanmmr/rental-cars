class SubsidiariesController < ApplicationController
  def new
    @subsidiary = Subsidiary.new
  end

  def create
    @subsidiary = Subsidiary.new(subsidiary_params)
    if @subsidiary.save
      flash[:notice] = t('.success')
      redirect_to subsidiaries_path
    else
      render :new
    end
  end

  def index
    @subsidiaries = Subsidiary.all
  end

  def show
    @subsidiary = Subsidiary.find(params[:id])
  end

  def edit
    @subsidiary = Subsidiary.find(params[:id])
  end

  def update
    @subsidiary = Subsidiary.find(params[:id])
    if @subsidiary.update(subsidiary_params)
      flash[:notice] = t('.success')
      redirect_to @subsidiary
    else
      render :edit
    end
  end

  def destroy
    Subsidiary.destroy(params[:id])
    redirect_to subsidiaries_path, notice: t('.success')
  end

  private

  def subsidiary_params
    params.require(:subsidiary).permit(:name, :address, :cnpj, :zip_code,
                                       :number, :district, :state, :city)
  end
end
