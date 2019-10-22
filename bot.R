library(telegram.bot)

#file.edit(path.expand(file.path("~", ".Renviron")))

# start handler function
start <- function(bot, update)
{
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = sprintf("Hello %s!",
                                 update$message$from$first_name))
}
# echo handler function
echo <- function(bot, update)
{
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = update$message$text)
}
# build the updater
updater <- Updater(token = bot_token("RTelegramBot")) +
  CommandHandler("start", start) +
  MessageHandler(echo, MessageFilters$text)



#Texte MAJ
caps <- function(bot, update, args){
  if (length(args > 0L)){
    text_caps <- toupper(paste(args, collapse = " "))
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = text_caps) 
  }
}

updater <- updater + CommandHandler("caps", caps, pass_args = TRUE)


# category handler function
cat <- function(bot, update)
{
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "Le plus grand nombre d'oeuvres d'art apparient à la catégorie Peinture")
}
updater <- updater + CommandHandler("cat", cat)

# Oeuvre handler function
oeuvre <- function(bot, update)
{
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "L'oeuvre la plus populaire aujourd'hui est Le livre Welcome Visitor de Shepard Fairey (Obey)")
}
updater <- updater + CommandHandler("oeuvre", oeuvre)


# Artiste handler function
artiste <- function(bot, update)
{
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "L'artiste le plus actif est Umberto Alizzi avec 42 oeuvres")
}
updater <- updater + CommandHandler("artiste", artiste)




# Example of a 'kill' command
kill <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "Bye!")
  # Clean 'kill' update
  bot$getUpdates(offset = update$update_id + 1L)
  # Stop the updater polling
  updater$stop_polling()
}

updater <<- updater + CommandHandler("kill", kill)




unknown <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "Erreur! Pas de réponse pour votre commande! ")
}

updater <- updater + MessageHandler(unknown, MessageFilters$command)







# start polling

updater$start_polling()


