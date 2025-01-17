\ProvidesClass{mcdowellcv}[2022/03/18 v1.2.0 McDowell CV class]

% Set up papersize according to options, default to US letter
\def\papersize{letterpaper}

%Set up bool for adjusting vspacing later
\newif\ifpapersize

\DeclareOption{a4paper}{%
  \def\papersize{a4paper}
  \papersizetrue
}

\DeclareOption{letterpaper}{%
  \def\papersize{letterpaper}
  \papersizefalse
}
\ProcessOptions\relax

% Set font size and paper type
\LoadClass[\papersize,10pt]{article}

% Set document margins
\usepackage[left=0.4in,top=0.4in,right=0.4in,bottom=0.4in]{geometry}

% Set font face
\usepackage{fontspec}
\setmainfont{LatinModernRoman}[
  SmallCapsFont=LatinModernRomanCaps,
  SmallCapsFeatures={},
  ItalicFeatures={SmallCapsFont=LMRomanCaps10-Oblique},
  BoldFeatures={SmallCapsFont=LMRomanCaps10-Regular},
  Ligatures={TeX}
]

% Remove paragraph indentation
\usepackage[parfill]{parskip}

% Required for boldface (\bf and \bfseries) tabular columns
\usepackage{array}

% Required for ifthenelse statements
\usepackage{etoolbox}

% Suppress page numbers
\pagestyle{empty}

% Flexible tables
% sudo tlmgr update --all
% sudo tlmgr install tabu
\usepackage{tabu}

% For custom margins
% sudo tlmgr install changepage
\usepackage{changepage}

% To customize lists
% sudo tlmgr install enumitem
\usepackage{enumitem}

% Remove left margin from lists, suppress vertical item separation and set top
% separation to a negative value to suppress a single parskip before lists
\setlist{leftmargin=*, noitemsep, topsep=-1\parskip}

% For adjusting spacing based on the platform used
\usepackage{ifthen}
\usepackage{ifplatform}

% For spaced small caps
\usepackage{microtype}

\DeclareMicrotypeSet*{smallcapsi} {
  encoding = {OT1,T1,T2A,LY1,OT4,QX,T5,TS1,EU1,EU2},
  shape = {sc*,si,scit}
}

% For URLs, see:
% https://tex.stackexchange.com/questions/23208/i-cannot-get-a-properly-underlined-hyperlink-in-blue
\usepackage{xcolor}
\usepackage[normalem]{ulem}
\usepackage{hyperref}
\hypersetup{colorlinks, urlcolor=blue}

% hack into hyperref
\makeatletter
\DeclareUrlCommand\ULurl@@{%
  \def\UrlFont{\ttfamily\color{blue}}%
  \def\UrlLeft{\uline\bgroup}%
  \def\UrlRight{\egroup}}
\def\ULurl@#1{\hyper@linkurl{\ULurl@@{#1}}{#1}}
\DeclareRobustCommand*\ULurl{\hyper@normalise\ULurl@}
\makeatother

%--------------------------------------------------------------------------------
%                                   Constants                                   -
%--------------------------------------------------------------------------------

\def\namespaceskip{0.575em}
\def\afterheaderspace{1.1pt}
\def\beforesectionheaderspace{5pt}
\def\sectionheadermargin{6pt}
\def\beforesectionheaderhrulespace{2.85pt}
\def\sectionheaderhruleheight{0.518pt}
\def\aftersectionheaderspace{-2pt}

\ifpapersize
  \def\aftersinglelinesubsectionheaderspace{-5.75pt}
\else
  \def\aftersinglelinesubsectionheaderspace{-7pt}
\fi

\def\afterdoublelinesubsectionheaderspace{-5pt}
\def\aftermultilinesubsectionheaderspace{-5pt}
\def\afteremptysubsectionheaderspace{1.25pt}
\def\subsectionmargin{9pt}
\def\aftersubsectionspace{2.1pt}

%--------------------------------------------------------------------------------
%                            Header Setup and Printing                          -
%--------------------------------------------------------------------------------

% Address
\makeatletter

\newcommand\address[1]{\def\@address{#1}}
\address{}

\newcommand\printaddress{
  \small{\@address}
}

\makeatother

% Name
\makeatletter

\newcommand\name[1]{\def\@name{#1}}
\name{}

\newcommand\printname{
  \spaceskip \namespaceskip \relax
  \textbf{\LARGE\textls[110]{\textsc{\@name}}}
}

\makeatother

% Contacts
\makeatletter

\newcommand\contacts[1]{\def\@contacts{#1}}
\contacts{}

\newcommand\printcontacts{
  \small{\@contacts}
}

\makeatother

\makeatletter
\newcommand\makeheader{
  \begin{center}
    \begin{tabu} to 1\textwidth { X[l,m] X[2,c,m] X[r,m] }
      \printaddress & \printname & \printcontacts \\
    \end{tabu}
  \end{center}
  \vspace*{\afterheaderspace}
}
\makeatother

%--------------------------------------------------------------------------------
%                            Sections and Subsections                           -
%--------------------------------------------------------------------------------

% Print a section header
\makeatletter
\newenvironment{cvsection}[1]{
  \vspace*{\beforesectionheaderspace}
  % Set text margins to equal \tabcolsep (6pt by default)
  \begin{adjustwidth}{\sectionheadermargin}{\sectionheadermargin}
    \textsc{\textbf{#1}}
  \end{adjustwidth}
  \vspace*{\beforesectionheaderhrulespace}
  \hrule height \sectionheaderhruleheight
  \vspace*{\aftersectionheaderspace}
}{}
\makeatother

% Print a subsection
\makeatletter
% Define toggles checking if titles were defined
\newtoggle{lefttitledefined}
\newtoggle{centertitledefined}
\newtoggle{righttitledefined}
\newenvironment{cvsubsection}[4][1]{
  \notblank{#2}{\toggletrue{lefttitledefined}}{}
  \notblank{#3}{\toggletrue{centertitledefined}}{}
  \notblank{#4}{\toggletrue{righttitledefined}}{}
  \ifboolexpr{togl {lefttitledefined} or togl {centertitledefined} or togl {righttitledefined}}{
    \begin{tabu} to 1\textwidth { X[l] X[c] X[r] }
      \textbf{#2} & \textbf{#3} & \textbf{#4} \\
    \end{tabu}
    % Add space according to the specified number of lines
    \ifnumcomp{#1}{=}{1}{\vspace*{\aftersinglelinesubsectionheaderspace}}{
      \ifnumcomp{#1}{=}{2}{\vspace*{\afterdoublelinesubsectionheaderspace}}{
        \vspace*{\aftermultilinesubsectionheaderspace}
      }
    }
  }{
    \vspace*{\afteremptysubsectionheaderspace}
  }
  \togglefalse{lefttitledefined}
  \togglefalse{centertitledefined}
  \togglefalse{righttitledefined}
  \begin{adjustwidth}{\subsectionmargin}{\subsectionmargin}
}
{
  \end{adjustwidth}
  \vspace*{\aftersubsectionspace}
}
\makeatother
