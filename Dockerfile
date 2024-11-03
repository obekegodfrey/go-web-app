###############
#Create a multi stage build dockerfile 
###############
#use the golang version 1.22.5 as base image
FROM golang:1.22.5 as base
#Set up working directory
WORKDIR /app
#copy the go.mod directory
COPY go.mod .
#Run 
RUN go mod download .
#Copy all the source code to the docker image
COPY  . .
#Run the binary file
RUN go build -o main .
##############
#Final Stage -Use the distorless image to reduce of the docker iamge amd make more secure
#############
#Use the distorless image the base
FROM gcr.io/distorless/base
#Copy the binary file(RUN go build -o main .) to the distroless image
COPY --from=base /app/main .
#Copy all the static files to a folder called static
COPY --from=base /app/static ./static
#Expose port
EXPOSE 8080
#Execute 
CMD [ "./main" ]