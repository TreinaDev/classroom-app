module Requestable
  private

  def join_path(*path_chunks)
    path = ''
    path_chunks.each { |chunk| path.insert(-1, chunk) }
    self::BASE_URL + path
  end
end
