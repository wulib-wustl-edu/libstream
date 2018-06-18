class MusicMailer < ApplicationMailer
  default from: 'CFU-LIBappmon@email.wustl.edu',
          to: ('phil.suda@wustl')

  def music_upload_alert(error)
    mail(subject: 'Music Upload Error', body: "Music Upload Error \n\n" + error.to_s)
  end
end
