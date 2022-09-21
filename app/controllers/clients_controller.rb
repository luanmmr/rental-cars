class ClientsController < ApplicationController
  def new
    @client = Client.new
  end

  def create
    @client = Client.new(params_client)
    return redirect_to clients_path, notice: t('.success') if @client.save

    render :new
  end

  def index
    @clients = Client.all
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    return redirect_to clients_path, notice: t('.success') \
    if @client.update(params_client)

    render :edit
  end

  def destroy
    Client.destroy(params[:id])
    redirect_to clients_path, notice: t('.success')
  end

  private

  def params_client
    params.require(:client).permit(:name, :email, :document)
  end
end
