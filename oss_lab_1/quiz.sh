##################################################
# chatziiol@ece.auth.gr @ 231030
## Η εκφώνηση της άσκησης περιέχεται μέσα στο αρχείο με την μορφή
## σχολίων μόνο για λόγους /αρχειοθέτησης/
### Γενικά, θα μπορούσα λίγο πολυ όλα να τα κάνω με πολύ απλούστερο
### τρόπο (πχ, το βήμα 1b με loop *ολοιδιο* του 1a) αλλά...
##################################################


#1. δημιουργήστε φάκελο `quiz-1/` στο home folder σας που περιέχει τα
#εξής: * 9 αρχεία που το ονομά τους προκύπτει από το AEM σας `+-{1,4}`
#κ το όνομα `file`, π.χ. για AEM 10000 θα έχουμε `file9996.txt` ως
#`file10004.txt`

# SUGGESTION Εδώ θα μπορούσε να βελτιωθεί η εκφώνηση γιατί στα 9
# αρχεία περιλαμβάνεται και το ΑΕΜ που δεν βγαίνει από τον τύπο
# +-{1,4} (και ακόμα η αποτύπωση του συνόλου δεν είναι σωστή, ούτε
# μαθηματικά, ούτε για bash)

# Replace it with $HOME before submitting
# Different variable used solely for development purposes
a=$HOME

##################################################
	# 1a) Make and populate quiz-1 dir
##################################################
cd $a
mkdir quiz-1
# Useful for cleanup as well
cd quiz-1

aem=10474
for ((i=0; i < 5; i++)); do
	echo '' > "file$((aem - i)).txt"
	echo '' > "file$((aem + i)).txt"
done

##################################################
	# 1b) Make and populate myfiles dir
##################################################

#* 1 φάκελο με ίδιο όνομα για το κάθε αρχείο κάτω απο τον φάκελο
#`myfiles`, δηλαδή το absolute path για τον χρήστη `bnas` θα είναι
#`/home/bnas/quiz-1/myfiles/folder9996/file9996.txt`. Φυσικά, όπου
#αναφέρεται το `bnas` εννοείται το δικό σας username.

## SUGGESTION Πάλι προβληματική η εκφώνηση μόνο η επεξήγηση δείχνει πως
## χρειάζεται και η μετακίνηση του αρχείου

mkdir myfiles
    
for txt in file*; do
    foldername="myfiles/$(echo $txt | cut -d. -f1)"
    mkdir $foldername
    mv $txt $foldername
done
	
##################################################
	# 2) Populate created text files
##################################################
#2. Γεμίστε το κάθε αρχείο με 20 τυχαίους συνδυασμούς των λέξεων (με
#χρήση του κελύφους και όχι χειροκίνητα) `banana chair tomato`

txtfiles=$(find $a -name '*.txt')

# $RANDOM (τυχαίος θετικός ακέραιος), και για να το αντιστοιχήσουμε
# αυτό με τις συμβολοσειρές στο $strings, %length (%3 στην προκειμένη)
strings=("banana" "chair" "tomato")

for txt in $txtfiles; do
    ## Populate the file
    for ((i=0; i<20; i++))do
	random_string="${strings[((RANDOM % 3))]}"
	echo $random_string >> $txt
    done
done

##################################################
	# 3) Create and populate report.txt
##################################################
#3. Μετρήστε πόσες φορές συναντάμε κάθε λέξη και παράξτε ένα αρχείο
#`report.txt` που θα βρίσκεται στο `/home/bnas/quiz-1/report.txt` και
#θα περιέχει τη μορφή:
#```
#/home/bnas/quiz-1/myfiles/folder9996/file9996.txt
#11 banana
#6 chair
#3 tomato
#
#```

touch report.txt
for txt in $txtfiles; do
    # Ignore empty lines (echo ''>...), sort, and count occurences
    echo $txt >> report.txt
    echo "$(cat $txt | grep -v '^$' | sort -nb | uniq -c | sort -r)" >> report.txt
    ## Empty line in given sample output
    echo '' >> report.txt
done 

##################################################
	# 4) Quiz1.log (this is it :P)
##################################################

#4. Φτιάξτε ένα αρχείο `quiz1.log` στο `/home/bnas/quiz-1/` που δείχνει ακριβώς ποιες εντολές χρησιμοποιήσατε. Αν κάποιος εκτελέσει με copy/paste τα περιεχόμενα του `quiz1.log` θα πρέπει να αναπαράγει τα βήματα 1-3 της άσκησης.

## DO NOT UNCOMMENT 
# scp -P 8112 quiz.sh chatziiol@155.207.200.6:~/quiz1.log
