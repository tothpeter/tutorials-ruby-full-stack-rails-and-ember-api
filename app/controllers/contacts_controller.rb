class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update, :destroy]

  # GET /contacts
  def index
    @contacts = Contact.all

    render json: @contacts
  end

  # GET /contacts/1
  def show
    render json: @contact
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)
    @contact.projects << (relationships_params[:projects] || [])
    @contact.company << (relationships_params[:company] || [])
    @contact.offers << (relationships_params[:offers] || [])

    if @contact.save
      render json: @contact, status: :created, location: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      @contact.projects = relationships_params[:projects] if relationships_params[:projects]
      @contact.company = relationships_params[:company] if relationships_params[:company]
      @contact.offers = relationships_params[:offers] if relationships_params[:offers]
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:data).require(:attributes).permit(:family_name, :given_names, :company_id, :title, :name, :phone, :email, :website, :address, :customer_id, :additional_info)
    end
end
