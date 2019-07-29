hugo --theme=hugo-tranquilpeak-theme --baseURL="https://hexbee.github.io/" -d ../ \
&& cd ../ \
&& git add . \
&& git commit -m "Auto update" \
&& git push \
&& echo "Done"
