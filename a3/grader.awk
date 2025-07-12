# awk program for processing student grades in csv format

BEGIN {
  # set field separator to comma
  FS = ","

  # set user defined variables for top and bottom scorers and scores
  # 0 for top score. some large number for bot score
  top_score = 0
  top_student = ""
  bot_score = 999999
  bot_student = ""
}

# function for calculating average score
# parameters: total student score and the number of courses
function calc_avg_score(total_score, num_courses) {
  if (num_courses > 0) {
    return total_score / num_courses
  } else {
    return 0
  }
}

# perform action block for every line following the header
NR > 1 {

  # store student id and name
  id = $1
  name = $2

  # students array stores name of each student
  #   index=student id, value=student name
  students[id] = name

  # num courses is num fields (NF) - 2 (id and name field)
  num_courses = NF - 2

  # calculate and store students total score
  # total_score array stores total score for each student
  #   index=student id, value = average score
  for (i = 3; i <= NF; i++) {
    total_score[id] += $i
  }

  # calculate and store student's average score using the function defined above
  # avg_score array stores average score for each student
  #   index=student id, value=average score
  avg_score[id] = calc_avg_score(total_score[id], num_courses)

  # determine and store pass/fail status of student
  # status array stores pass/fail status for each student
  #   index=student id, value="Pass" or "Fail"
  if (avg_score[id] >= 70) {
    status[id] = "Pass"
  } else {
    status[id] = "Fail"
  }

  # compare student's score with the current top score
  # update top score and student if their score is higher
  if (total_score[id] > top_score) {
    top_score = total_score[id]
    top_student = students[id]
  }

  # compare student's score with the current bottom score
  # update bottom score and student if their score is lower
  if (total_score[id] < bot_score) {
    bot_score = total_score[id]
    bot_student = students[id]
  }
}

END {
  print "\n======================================="
  print "          Student Grade Records        "
  print "======================================="
  for (id in students) {
    printf "Student Name: %s\n", students[id]
    printf "Total Score: %d\n", total_score[id]
    printf "Average Score: %.2f\n", avg_score[id]
    printf "Status: %s\n", status[id]
    print "---------------------------------------"
  }

  print "\n======================================="
  print "    Top and Bottom Scoring Students    "
  print "======================================="
  printf "Top Student: %s\n", top_student
  printf "Score: %d\n", top_score
  print "---------------------------------------"
  printf "Bottom Student: %s\n", bot_student
  printf "Score: %d\n", bot_score
  print "=======================================\n"
}

