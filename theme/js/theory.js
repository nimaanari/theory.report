function showHeadlines(){
  $('.tr-article').prop('open', false);
}

function showFullText() {
  $('.tr-article-summary').toggle(true);
  $('.tr-article-snippet').toggle(false);
  $('.tr-article').prop('open', true);
}

function showSnippets() {
  $('.tr-article-summary').toggle(false);
  $('.tr-article-snippet').toggle(true);
  $('.tr-article').prop('open', true);
}

function togglePanel(){
  $('.tr-articles').toggleClass('tr-shrink', this.open);
}

$(document).ready( function() {
  jQuery("time.timeago").timeago();
  
  $('details.tr-panel').on('toggle', togglePanel);

  $('#tr-show-headlines').click(showHeadlines);
  $('#tr-show-fulltext').click(showFullText);
  $('#tr-show-snippets').click(showSnippets);

  if (window.matchMedia('(max-width: 767px)').matches){
    $('details.tr-panel').prop('open', false);
  }
});

