class TranscoderWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :transcode

  def perform(klass, input_path, transcode_path, eventual_path)
    klass = klass.constantize

    if File.exist?(eventual_path) # don't convert it again!
      puts "Video already transcoded and moved; creating"
      klass.create(raw_file_path: eventual_path)
      return true
    end
    if File.exist?(transcode_path)
      puts "Video already transcoded; moving and creating"
      move_transcoded_file(transcode_path, eventual_path)
      klass.create(raw_file_path: eventual_path)
      return true
    end

    # HEAVY WORK
    %x(#{transcode_to_webm_command(input_path, transcode_path)})

    if File.exist? eventual_path
      puts "Video transcoded successfully; moving and creating"
      move_transcoded_file(transcode_path, eventual_path)
      klass.create(raw_file_path: eventual_path)
      return true
    else
      raise "Conversion seems to have failed"
    end
  end

  def move_transcoded_file(transcode_path, eventual_path)
    FileUtils.copy(transcode_path, eventual_path)
    begin
      File.delete(transcode_path)
    rescue Exception => e
      Rails.logger.info "TranscoderWorker: deleting transcoded file: #{e}"
    end
  end

  def transcode_to_webm_command(input_path, output_path)
    "avconv -i #{input_path.to_s.shellescape} -c:v libvpx -qmin 0 -qmax 50 -b:v 1M -c:a libvorbis -q:a 4 #{output_path.to_s.shellescape}"
  end
end
