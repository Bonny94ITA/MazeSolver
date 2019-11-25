import tkinter as tk
import tkinter.messagebox

fields = ('Righe', 'Colonne')
matrix = []
radio = 0


def maze_generation():
    file = open("labirinto.pl", "w")
    for row in range(len(matrix)):
        for col in range(len(matrix[row])):
            # print(matrix[row][col], end=' ')
            if matrix[row][col]["relief"] == tk.SUNKEN:
                if matrix[row][col]["bg"] == "dodger blue":
                    string = "occupata(pos(" + str(row + 1) + "," + str(col + 1) + ")).\n"
                elif matrix[row][col]["bg"] == "red":
                    string = "iniziale(pos(" + str(row + 1) + "," + str(col + 1) + ")).\n"
                else:
                    string = "finale(pos(" + str(row + 1) + "," + str(col + 1) + ")).\n"
                file.write(string)
        # print()
    file.write("\nnum_righe(" + str(row + 1) + ").\n")
    file.write("num_col(" + str(col + 1) + ").\n")
    file.close()
    tkinter.messagebox.showinfo("info", "Labirinto Generato!!")


def selection(radioButton):
    global radio
    radio = radioButton.cget("value")


def block_label(label, state):
    i = int(label.cget("text")) + state
    label.config(text=str(i), anchor='center')


def clicked(row, col, lab2):
    print("Cordinate", row + 1, col + 1)
    if radio == 0:
        if matrix[row][col]["relief"] == tk.RAISED:
            matrix[row][col].config(relief=tk.SUNKEN, bg="dodger blue", highlightcolor="dodger blue",
                                    highlightbackground="dodger blue")
            block_label(lab2, 1)
        else:
            matrix[row][col].config(relief=tk.RAISED, bg="SystemButtonFace", highlightcolor="SystemButtonFace",
                                    highlightbackground="SystemButtonFace")
            block_label(lab2, -1)
    elif radio == 1:
        if matrix[row][col]["relief"] == tk.RAISED:
            matrix[row][col].config(relief=tk.SUNKEN, bg="red", highlightcolor="red", highlightbackground="red")
        else:
            matrix[row][col].config(relief=tk.RAISED, bg="SystemButtonFace", highlightcolor="SystemButtonFace")
    else:
        if matrix[row][col]["relief"] == tk.RAISED:
            matrix[row][col].config(relief=tk.SUNKEN, bg="green", highlightcolor="green", highlightbackground="green")
        else:
            matrix[row][col].config(relief=tk.RAISED, bg="SystemButtonFace", highlightcolor="SystemButtonFace")


def mazeGenerator(entries):
    maze = tk.Tk()
    maze.title("Maze")

    col = int(entries['Colonne'].get())
    row = int(entries['Righe'].get())

    lab1 = tk.Label(maze, width=25, text="Muri utilizzati: ", anchor='w')
    lab2 = tk.Label(maze, width=25, fg="green", anchor='w')
    lab2.config(text=str(0), anchor='center')
    radioButton1 = tk.Radiobutton(maze, text="MURO", value=0, command=lambda: selection(radioButton1))
    radioButton2 = tk.Radiobutton(maze, text="INIZIO", value=1, command=lambda: selection(radioButton2))
    radioButton3 = tk.Radiobutton(maze, text="FINE", value=2, command=lambda: selection(radioButton3))
    button = tk.Button(maze, text="Genera labirinto in Prolog", command=lambda: maze_generation(), width=25)

    for i in range(row):
        tmp1 = []
        for j in range(col):
            tmp2 = tk.Button(maze, relief=tk.RAISED, command=lambda c=i, b=j: clicked(c, b, lab2), width=5)
            tmp1.append(tmp2)
            tmp2.grid(row=i, column=j)
        matrix.append(tmp1)

    lab1.grid(column=j + 1, row=0)
    lab2.grid(column=j + 1, row=1)
    radioButton1.grid(column=j + 1, row=2, sticky=tk.W)
    radioButton2.grid(column=j + 1, row=3, sticky=tk.W)
    radioButton3.grid(column=j + 1, row=4, sticky=tk.W)
    button.grid(column=j + 1, row=5)

    maze.mainloop()


def makeform(root, fields):
    entries = {}
    for field in fields:
        print(field)
        row = tk.Frame(root)
        lab = tk.Label(row, width=10, text=field + " : ", anchor='w')
        ent = tk.Entry(row)
        ent.insert(0, "10")
        row.pack(side=tk.TOP,
                 fill=tk.X,
                 padx=5,
                 pady=5)
        lab.pack(side=tk.LEFT)
        ent.pack(side=tk.RIGHT,
                 expand=tk.YES,
                 fill=tk.X)
        entries[field] = ent
    return entries


if __name__ == '__main__':
    root = tk.Tk()
    root.title("Maze Generator")
    form = makeform(root, fields)
    b1 = tk.Button(root, text='Costruisci Labirinto', command=(lambda e=form: mazeGenerator(e)))
    b1.pack(side=tk.LEFT, padx=100, pady=10)
    root.mainloop()
