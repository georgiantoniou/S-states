int main() {

int i = 0;
int x=1;
int y=1;

while (i < 234000000 ) {
 
    x = x + y;
    y = y + 1;
    x = x + y;
    y = y + 1;
    x = x + y;
    y = y + 1;
    x = x + y;
    y = y + 1;
    i=i+1;
}

}