class MusicMailer < ApplicationMailer
  default from: Figaro.env.from_email,
          to: (Figaro.env.to_email)

  def music_upload_alert(error)
    mail(subject: 'Music Upload Error', body: "Music Upload Error \n\n" + error.to_s)
  end


  def music_destroy_alert(error)
    mail(subject: 'Music Destroy Error', body: "Music Destroy Error \n\n" + error.to_s)
  end

  def music_jwcall_alert(error)
    mail(subject: 'Music JW Player API Error', body: "Music JW Player API Error \n\n" + error.to_s)
  end

  def music_tinytds_alert(error)
    mail(subject: 'Music ARES Call Error', body: "Music Ares Call Error \n\n" + error.to_s)
  end
end
