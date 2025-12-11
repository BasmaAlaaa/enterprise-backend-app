class Api::StatisticsController < Api::BaseController

  def show
    statistics=Statistics.find_by(integration_id: params[:id])
    return unless statistics.present?
    render(json: { statistics: statistics })
  end

end