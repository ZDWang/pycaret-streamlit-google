FROM python:3.7

#RUN groupadd -g 999 appuser && \
#    useradd -r -u 999 -g appuser appuser
#USER appuser

#RUN pip install virtualenv
#ENV VIRTUAL_ENV=/venv
#RUN virtualenv venv -p python3
#ENV PATH="VIRTUAL_ENV/bin:$PATH"

WORKDIR /app
ADD . /app

# Install dependencies
#RUN pip install -r requirements.txt
RUN pip install --upgrade streamlit pycaret

# copying all files over
COPY . /app

# streamlit-specific commands for config
#ENV LC_ALL=C.UTF-8
#ENV LANG=C.UTF-8
#RUN mkdir -p ~/.streamlit
#RUN bash -c 'echo -e "\
#[general]\n\
#email = \"\"\n\
#" > ~/.streamlit/credentials.toml'

#RUN bash -c 'echo -e "\
#[server]\n\
#enableCORS = false\n\
#" > ~/.streamlit/config.toml'

# Expose port 
ENV PORT 8501

# cmd to launch app when container is run
CMD streamlit run app.py
