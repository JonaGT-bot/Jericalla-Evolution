import tkinter as tk
from tkinter import filedialog, scrolledtext

diccionario_instrucciones = {
    "SUMA $4, $0, $1": "00001000000000001",
    "RESTA$5, $1, $2": "01001010000100010",
    "STL $6, $2, $3": "10001100001000011",
    "StoreWord $x, $7, $4": "11000000011100100",
    "StoreWord $x, $8, $5": "11000000100000101",
    "StoreWord $x, $9, $6": "11000000100100110"
}

def cargar_archivo():
    archivo = filedialog.askopenfilename(filetypes=[("Archivos ASM", "*.asm")])
    if archivo:
        with open(archivo, "r") as f:
            contenido = f.readlines()
        entrada_texto.delete("1.0", tk.END)
        salida_texto.delete("1.0", tk.END)
        for linea in contenido:
            entrada_texto.insert(tk.END, linea)
            binario = diccionario_instrucciones.get(linea.strip(), "ERROR: Instrucción no reconocida")
            salida_texto.insert(tk.END, binario + "\n")

def guardar_traduccion():
    archivo = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Archivos de texto", "*.txt")])
    if archivo:
        with open(archivo, "w") as f:
            f.write(salida_texto.get("1.0", tk.END))

# Configuración de la interfaz
tk_interfaz = tk.Tk()
tk_interfaz.title("Traductor ASM a Binario")
tk_interfaz.geometry("600x400")

btn_cargar = tk.Button(tk_interfaz, text="Cargar ASM", command=cargar_archivo)
btn_cargar.pack()

entrada_texto = scrolledtext.ScrolledText(tk_interfaz, height=10)
entrada_texto.pack()

salida_texto = scrolledtext.ScrolledText(tk_interfaz, height=10)
salida_texto.pack()

btn_guardar = tk.Button(tk_interfaz, text="Guardar Traducción", command=guardar_traduccion)
btn_guardar.pack()

tk_interfaz.mainloop()