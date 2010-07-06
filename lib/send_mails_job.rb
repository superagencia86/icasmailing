class SendMailsJob 
  # Eliminamos los pedidos expirados
  def perform
    Mail.process(:limit => 50)
    Delayed::Job.enqueue(SendMailsJob.new, 0, 30.seconds.from_now)
  end
end
