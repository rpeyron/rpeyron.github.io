// https://github.com/J911/jekyll-infinite-scroll  (modified)

class InfiniteScroll {

    /**
     * @wrapperSelector  selector for items wrapper
     * @paginationSelector   selector for navigation container
     * @paginationNextSelector  selector for next element to detect next page and url
     * @path if defined, will override url from paginationNextSelector (and force path/:pagenum/index.html)
     */
    constructor (wrapperSelector, paginationSelector, paginationNextSelector, path) {
        if (paginationSelector === undefined || paginationNextSelector === undefined ||wrapperSelector === undefined) throw Error ('no parameter.');
        this.path = path;
        this.pNum = 2;
        this.wNode = document.querySelector(`${wrapperSelector}`);
        this.wrapperSelector = wrapperSelector;
        this.paginationSelector = paginationSelector;
        this.paginationNextSelector = paginationNextSelector;
        this.enable = true;

        this.detectScroll();
    }

    detectScroll() {
        window.onscroll = (ev) => {
            if ((2*window.innerHeight + Math.ceil(window.pageYOffset)) >= document.body.offsetHeight) 
                this.getNewPost();
        };    
    }
    async getNewPost() {
        if (this.enable === false) return false;
        this.enable = false;

        const pagination = document.querySelector(this.paginationSelector);
        const paginationNext = document.querySelector(this.paginationNextSelector);

        if (paginationNext && paginationNext.getAttribute('href')) {
            // We have a next page

            // Replace pagination by spinner
            pagination.innerHTML = "<div class='spinner'></div>"

            var url = (this.path) ? `${location.origin + this.path + this.pNum}/index.html` : paginationNext.getAttribute('href')

            const response = await fetch(url);
            if(response.ok) {
                const responseText = await response.text();

                const newHTML = document.createElement('html');
                newHTML.innerHTML = responseText;

                // Replace children
                const childItems = newHTML.querySelectorAll(`${this.wrapperSelector} > *`);
                childItems.forEach(item => {
                    this.wNode.appendChild(item);
                });

                // Replace pagination
                pagination.innerHTML = newHTML.querySelector(this.paginationSelector).innerHTML;

                this.pNum++;
                return this.enable = true;                                
            }
    
        } else {
            // End of pages, we clear navigation
            pagination.innerHTML = ""
        }

   }


}