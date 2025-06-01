FROM mcr.microsoft.com/playwright:focal

# Skip Playwright browser downloads
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# Set timezone
ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

# Clone repository
RUN git clone https://github.com/zennn08/brat-api .

# Install dependencies
RUN npm install

# Install Playwright dependencies and browsers
RUN npx playwright install --with-deps

# Install additional dependencies for fonts
RUN apt-get update && apt-get install -y \
  wget \
  fontconfig \
  fonts-noto-color-emoji \
  fontconfig \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Download and install AppleColorEmoji.ttf
RUN mkdir -p /usr/share/fonts/AppleColorEmoji && \
  wget -O /usr/share/fonts/AppleColorEmoji/AppleColorEmoji.ttf \
  https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf && \
  fc-cache -f -v

RUN fc-list | grep -i "AppleColorEmoji"

# Set environment variable for the app port
ENV PORT=7860

# Expose the port
EXPOSE 7860

# Start the application
CMD ["node", "app.js"]
