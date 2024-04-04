{config, ...}:
/*
css
*/
''
  @-moz-document url(about:home), url(about:newtab), url(about:privatebrowsing) {
    body::before {
      content: "";
      z-index: -1;
      position: fixed;
      top: 0;
      left: 0;
      background-image: url('${config.settings.browser.firefox.newtab_image}');
      background-repeat: no-repeat;
      background-position: center;
      background-size: cover;
      width: 100vw;
      height: 100vh;
      margin: 0 !important;
      padding: 0 !important;
      filter: blur(6px);
    }

    body::after {
      content: "Jeg vet ikke hva jeg skal skrive her\A Sett inn et eller annet";
      /* content: "I’d just like to interject for a moment. What you’re refering to as Linux, is in fact, GNU/Linux, or as I’ve recently taken to calling it, GNU plus Linux. Linux is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX.\A Many computer users run a modified version of the GNU system every day, without realizing it. Through a peculiar turn of events, the version of GNU which is widely used today is often called Linux, and many of its users are not aware that it is basically the GNU system, developed by the GNU Project.\A There really is a Linux, and these people are using it, but it is just a part of the system they use. Linux is the kernel: the program in the system that allocates the machine’s resources to the other programs that you run. The kernel is an essential part of an operating system, but useless by itself; it can only function in the context of a complete operating system. Linux is normally used in combination with the GNU operating system: the whole system is basically GNU with Linux added, or GNU/Linux. All the so-called Linux distributions are really distributions of GNU/Linux!"; */
      white-space: pre; /* Makes \A do newline, but disables line wrapping as a side-effect */
      color: #${config.colorScheme.palette.base07};
      z-index: 1;
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 50vh;
      font-size: 1em;
      text-align: center;
      display: grid;
      place-items: center;
    }

    .icon-settings {
      display: none !important;
    }
  }
''
