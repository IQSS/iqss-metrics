# customInfoBox---------------

customInfoBox <-
  function(title,
           tab = NULL,
           value = NULL,
           subtitle = NULL,
           icon = shiny::icon("bar-chart"),
           color = "aqua",
           width = 4,
           href = NULL,
           fill = FALSE) {
    # validateColor(color)
    # tagAssert(icon, type = "i")
    colorClass <- paste0("bg-", color)
    
    if (!is.null(tab)) {
      href <- "#"
    }
    
    boxContent <- div(
      class = "info-box",
      class = if (fill)
        colorClass,
      onclick = if (!is.null(tab))
      {
        paste0(
          "event.preventDefault(); $('.nav a').filter(function() { return ($(this).attr('data-value') === '",
          tab,
          "')}).click()"
        )
      },
      span(class = "info-box-icon", class = if (!fill)
        colorClass, icon),
      div(
        class = "info-box-content",
        span(class = "info-box-text", title),
        if (!is.null(value))
          span(class = "info-box-number", value),
        if (!is.null(subtitle))
          p(subtitle)
      ),
      style = "max-height:90px;"
    )
    if (!is.null(href))
      boxContent <- a(href = href, boxContent)
    div(class = if (!is.null(width))
      paste0("col-sm-", width), boxContent)
  }
