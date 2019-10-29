class TokensController < ApplicationController
  before_action :set_pos
  before_action :set_token, only: [:show, :edit, :update, :destroy]

  # GET /tokens
  # GET /tokens.json
  def index
    # filter params
    search = params[:search] || ""
    #pos = params[:pos] || ""
    #begin
    #  date = Date.strptime(params[:date] || "", "%Y-%m-%d").strftime("%Y-%m-%d")
    #rescue
    #  date = Date.current.strftime("%Y-%m-%d")
    #end
    perpage = params[:perpage].to_i
    perpage = Kaminari.config.default_per_page if perpage < 1
    perpage = [perpage, 500].min

    @search = search
    #@pos = pos
    #@date = date
    @perpage = perpage

    #@poses = Token.all.map(&:pos).sort.uniq
    #@dates = Token.all.map(&:created_at).map{|x|x.strftime "%Y-%m-%d"}.sort.uniq

    @tokens = Token.all.search(search)
    #if !pos.empty? and @poses.include?(pos)
    #  @tokens = @tokens.where(pos: pos)
    #end
    #if !date.empty? and @dates.include?(date)
    #  x = Date.strptime(date, "%Y-%m-%d")
    #  @tokens = @tokens.where(created_at: x.midnight..x.end_of_day)
    #end
    @tokens = @tokens.order(:course, :number, :pos, :hiragana, :katakana, :kanji, :created_at, :id)

    respond_to do |format|
      format.html do
        @size = @tokens.size
        @tokens = @tokens.page(params[:page]).per(@perpage)
      end
      format.pdf do
        send_data CardsPdf.new(@tokens).render,
          filename: "cards.pdf",
          type: "application/pdf",
          disposition: 'inline'
      end
    end
  end

  # GET /tokens/1
  # GET /tokens/1.json
  def show
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # GET /tokens/1/edit
  def edit
  end

  # POST /tokens
  # POST /tokens.json
  def create
    @token = Token.new(token_params)

    respond_to do |format|
      if @token.save
        format.html { redirect_to @token, notice: 'Token was successfully created.' }
        format.json { render :show, status: :created, location: @token }
      else
        format.html { render :new }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tokens/1
  # PATCH/PUT /tokens/1.json
  def update
    respond_to do |format|
      if @token.update(token_params)
        format.html { redirect_to @token, notice: 'Token was successfully updated.' }
        format.json { render :show, status: :ok, location: @token }
      else
        format.html { render :edit }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tokens/1
  # DELETE /tokens/1.json
  def destroy
    @token.destroy
    respond_to do |format|
      format.html { redirect_to tokens_url, notice: 'Token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_token
      @token = Token.find(params[:id])
    end

    def set_pos
      jp = ["名", "代", "動I", "動II", "動III", "形", "形動", "副", "連体", "接", "感", "助動", "助", "頭", "尾", "連"]
      en = ["noun", "pronoun", "Type I verb", "Type II verb", "Type III verb", "adjective", "adjectival noun", "adverb", "attribute", "conjunction", "interjection", "auxiliary", "particle", "prefix", "suffix", "compound"]
      @pos = [jp, en].transpose.to_h
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:hiragana, :katakana, :kanji, :german, :pos)
    end
end
