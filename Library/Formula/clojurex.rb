require 'formula'

class Clojurex <Formula
  head 'git://github.com/citizen428/ClojureX.git', :tag => '0.3.0'
  homepage 'http://github.com/citizen428/ClojureX'

  depends_on 'git'
  depends_on 'maven'

  def initialize(*args)
    super
    @version = '0.3.0'
  end

  def install
    cache = "#{HOMEBREW_CACHE}/#{name}-#{version}"
    cd cache

    system "git submodule init"
    system "git submodule update"
    system "ant"

    # prefix.install cannot be used because each jar lives in its own subdir
    # external scripts reference the subdir
    mkdir "#{prefix}/clojure"
    mkdir "#{prefix}/clojure-contrib"
    mkdir "#{prefix}/jline"

    `cp clojure/clojure.jar                 #{prefix}/clojure/clojure.jar` 
    `cp jline/jline.jar                     #{prefix}/jline/jline.jar` 
    `cp clojure-contrib/clojure-contrib.jar #{prefix}/clojure-contrib/clojure-contrib.jar` 
    `cp configure_emacs                     #{prefix}/configure_emacs`
    `cp configure_textmate                  #{prefix}/configure_textmate`
    `cp generate_completions                #{prefix}/generate_completions`
    `cp clojure-completions                 #{prefix}/clojure-completions`

    # this is nice if you want to reference swank.jar in your app
    cd     "swank-clojure"
    system "mvn jar:jar"
    `cp target/swank-clojure-1.0-SNAPSHOT.jar ../`
    
    # change it to cljx so it doesn't collide with clojure formula
    `cp    #{cache}/clj              #{prefix}` 
    `cp -r #{cache}/swank-clojure    #{prefix}`
    `cp -r #{cache}/slime            #{prefix}`
    `cp -r #{cache}/clojure-mode     #{prefix}`
    `cp -r #{cache}/Clojure.tmbundle #{prefix}`

    # creating the symlink directly into homebrew/bin
    # so full path will be used instead of relative
    FileUtils.ln_s "#{prefix}/clj", "#{prefix}/../../../bin/cljx"
  end
end
