class Api::MarksController < ApiController
  before_filter :authenticate

	def index
		@marks = Mark.all
		
    respond_to do |format|
      format.json { render json: @marks }
    end
  end

  def show
  	@mark = Mark.find params[:id]
		respond_to do |format|
	    format.json { render json: @mark.to_json }
	  end
  end

  def create
    #@mark = Mark.create(params[:mark])
    #render 'api/marks/create'
    car = params[:car]
    #puts ">>>>>>>>>>>>  car: car.each {|c| puts c.placa}"
    car.each {|c| puts ">>>>>>>>>>>> #{c[:placa]} "} if params[:car]

    name = params[:mark][:nome]

    @mark = Mark.new(name: name)
    if @mark.save
      #render 'api/marks/create'
      render(notice: 'Mark was successfully created.');
    else
      render(:json => @mark.errors.to_json, :status => 404)
    end
  end

  private
    def mark_params
      params.require(:mark).permit(:name)
    end

  def authenticate
    login = authenticate_or_request_with_http_basic do |name, pass|
      name == 'admin' && pass == 'secret'
    end
    #session[:login] = login
    if !login
      render(:json => {error: "HTTP Basic: Access denied."})
    end
  end
end

